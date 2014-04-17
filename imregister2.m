function [moving_reg, tform] = imregister2(varargin)
%   imregister Register two 2-D images using intensity metric optimization.
%   MOVING_REG = IMREGISTER(MOVING, FIXED, TRANSFORMTYPE, OPTIMIZER, METRIC)
%   transforms the moving image MOVING so that it is spatially registered
%   with the FIXED image.  MOVING and FIXED must both be 2-D.
%   TRANSFORMTYPE is a string that defines the type of transformation to
%   perform.  OPTIMIZER is an object that describes the method for
%   optimizing the similarity metric.  METRIC is an object that specifies
%   the image similarity metric to optimize.  The output MOVING_REG is a
%   transformed version of MOVING.
%
%   TRANSFORMTYPE is a string specifying one of the following geometric
%   transform types:
%
%      TRANSFORMTYPE         TYPES OF DISTORTION
%      -------------         -----------------------
%      'translation'         Translation
%      'rigid'               Translation, Rotation
%      'similarity'          Translation, Rotation, Scale
%      'affine'              Translation, Rotation, Scale, Shear
%
%   The 'similarity' and 'affine' transform types always involve
%   nonreflective transformations.
%
%   [...] = IMREGISTER(...,PARAM1,VALUE1,PARAM2,VALUE2,...) registers the
%   moving image using parameter/value pairs to control aspects of the
%   registration.
%
%   Parameters include:
%
%      'DisplayOptimization'   - A logical scalar specifying whether or
%                                not to display optimization information
%                                to the MATLAB command prompt. The default
%                                is false.
%                                
%      'PyramidLevels'         - The number of multi-level image pyramid
%                                levels to use. The default is 3.
%
%   Class Support
%   -------------
%   MOVING and FIXED are numeric matrices.  TRANSFORMTYPE is a string.
%   METRIC_CONFIG is an object from the registration.metric package.
%   OPTIMIZER_CONFIG is an object from the registration.optimizer
%   package.
%
%   Notes
%   -------------
%   Getting good results from optimization-based image registration
%   usually requires modifying optimizer and/or metric settings for
%   the pair of images being registered.  The imregconfig function
%   provides a default configuration that should only be considered
%   a starting point.  See the output of the imregconfig for more
%   information on the different parameters that can be modified.
%   
%   Example 
%   -------------
%   % Read in two slightly misaligned magnetic resonance images of a knee
%   % obtained using different protocols.
%   fixed  = dicomread('knee1.dcm');
%   moving = dicomread('knee2.dcm');
%
%   % View misaligned images
%   imshowpair(fixed, moving,'Scaling','joint');
%
%   % Get a configuration suitable for registering images from different
%   % sensors.
%   [optimizer, metric] = imregconfig('multimodal')
%
%   % Tune the properties of the optimizer to get the problem to converge
%   % on a global maxima and to allow for more iterations.
%   optimizer.InitialRadius = 0.009;
%   optimizer.Epsilon = 1.5e-4;
%   optimizer.GrowthFactor = 1.01;
%   optimizer.MaximumIterations = 300;
%
%   % Align the moving image with the fixed image
%   movingRegistered = imregister(moving, fixed, 'affine', optimizer, metric);
%
%   % View registered images
%   figure
%   imshowpair(fixed, movingRegistered,'Scaling','joint');
%   
%   See also IMREGCONFIG, IMSHOWPAIR, IMTRANSFORM,
%   registration.metric.MattesMutualInformation,
%   registration.metric.MeanSquares,
%   registration.optimizer.RegularStepGradientDescent
%   registration.optimizer.OnePlusOneEvolutionary

%   Copyright 2011 The MathWorks, Inc.
%   $Revision: 1.1.6.10.2.2 $ $Date: 2012/01/14 04:21:43 $

parsedInputs = parseInputs(varargin{:});

parsedInputs.InitialParams = [];

moving        = parsedInputs.MovingImage;
fixed         = parsedInputs.FixedImage; 
transformType = parsedInputs.TransformType;
dispOptim     = parsedInputs.DisplayOptimization;
initialParams = parsedInputs.InitialParams;
optimConfig   = parsedInputs.OptimConfig;
metricConfig  = parsedInputs.MetricConfig;
pyramidLevels = parsedInputs.PyramidLevels;


initialParamsSpecified = ~isempty(initialParams);
if (~initialParamsSpecified)

    % If user does not specify guess as to initial parameters to use, use
    % normxcorr to at least achieve best posible alignment in translation.
    translationVector = findtranslation(fixed, moving);

    initialParams = computeInitialRegParams(transformType, ...
                                            translationVector);
        
end

% Set optimizer scales.
optimConfig = setOptimScales(optimConfig, transformType,size(fixed));

% Ensure that parameters and scales match the transformation type.
validateInitialParams(initialParams, transformType);

% Cast to double before handing to MEX. ITK registration requires floating
% point representation of source imagery.
t = regmex(double(moving), ...
    double(fixed),...
    dispOptim,...
    transformType, ...
    initialParams, ...
    optimConfig, ...
    metricConfig,...
    pyramidLevels);

tform = maketform('affine',t);

moving_reg = transformMovingImage(moving, fixed, tform);

if dispOptim
    printTransformCoefficients(tform);
end
   
end

function printTransformCoefficients(tform)

    disp(' ');
    disp(sprintf(getString(message('images:imregister:tformStructHowTo','T','tform struct'))));
    
    disp(' ');
    disp(getString(message('images:imregister:useResultingStruct','tform struct','imtransform')));
    disp(' ');
    
    T = tform.tdata.T';
    disp(sprintf('t = [%-15e %-15e %e;...',T(1:3))); %#ok<*DSPS>
    disp(sprintf('     %-15e %-15e %e;...',T(4:6)));
    disp(sprintf('     %-15e %-15e %e];',T(7:9)));
    
    disp(' ');
    disp('T = maketform(''affine'',t)');
    
    disp(' ');
                                   
end


function parsedInputs = parseInputs(varargin)

parser = inputParser();

parser.addRequired('MovingImage',@checkMovingImage);
parser.addRequired('FixedImage',@checkFixedImage);
parser.addRequired('TransformType',@checkTransform);
parser.addRequired('OptimConfig',@checkOptim);
parser.addRequired('MetricConfig',@checkMetric);

parser.addParamValue('DisplayOptimization', false, @checkDisplay);
parser.addParamValue('PyramidLevels',3,@checkPyramidLevels);

% Function scope for partial matching
parsedTransformString = '';

% Parse input, replacing partial name matches with the canonical form.
if (nargin > 5)
  varargin(6:end) = remapPartialParamNames({'DisplayOptimization', 'PyramidLevels'}, ...
                                           varargin{6:end});
end

parser.parse(varargin{:});

parsedInputs = parser.Results;

% Make sure that there are enough pixels in the fixed and moving images for
% the number of pyramid levels requested.
validatePyramidLevels(parsedInputs.FixedImage,parsedInputs.MovingImage, parsedInputs.PyramidLevels);

% Allows us to be consistent with rest of toolbox in allowing scalar
% numeric values to be used interchangably with logicals.
parsedInputs.DisplayOptimization = logical(parsedInputs.DisplayOptimization);

parsedInputs.TransformType = parsedTransformString;


    function tf = checkPyramidLevels(levels)
        
        validateattributes(levels,{'numeric'},{'scalar','real','positive','nonnan'},'imregister','PyramidLevels');
        
        tf = true;
        
    end

    function tf = checkOptim(optimConfig)
       
        validOptimizer = isa(optimConfig,'registration.optimizer.RegularStepGradientDescent') ||...
                         isa(optimConfig,'registration.optimizer.GradientDescent') ||...
                         isa(optimConfig,'registration.optimizer.OnePlusOneEvolutionary');
                     
        if ~validOptimizer
           error(message('images:imregister:invalidOptimizerConfig'))
        end
        tf = true;
        
    end

    function tf = checkMetric(metricConfig)
       
        % TODO: It would be much cleaner to do this check if metrics all
        % subclassed off of a common base class.
        validMetric = isa(metricConfig,'registration.metric.MeanSquares') ||...
                      isa(metricConfig,'registration.metric.MutualInformation') ||...
                      isa(metricConfig,'registration.metric.MattesMutualInformation');
                  
        if ~validMetric
           error(message('images:imregister:invalidMetricConfig'))
        end
        tf = true;
        
    end

    %---------------------------
     function tf = checkFixedImage(img)
        
        validateattributes(img,{'numeric'},{'real','2d','nonempty','nonsparse','finite','nonnan'},'imregister','fixed',1);
        
        tf = true;
        
    end

    %---------------------------
    function tf = checkMovingImage(img)
        
        validateattributes(img,{'numeric'},{'real','2d','nonempty','nonsparse','finite','nonnan'},'imregister','moving',2);

        [r,c] = size(img);
        if (r < 4) || (c < 4)
             error(message('images:imregister:minMovingImageSize'));
        end
 
        tf = true;
        
    end

    %---------------------------
    function tf = checkTransform(tform)
        parsedTransformString = validatestring(lower(tform), {'affine','translation','rigid','similarity'}, ...
            'imregister', 'TransformType');
        
        tf = true;
        
    end
    
    function tf = checkDisplay(TF)
        
        validateattributes(TF,{'logical','numeric'},{'real','scalar'});
        
        tf = true;
        
    end
 
end


function moving_reg = transformMovingImage(moving, fixed, tform)
% Call |imtransform|, specifying an output grid that aligns with the fixed image.

[M, N] = size(fixed);

moving_reg = imtransform(moving, tform, 'XData', [1 N], 'YData', [1 M], ...
   'Size', [M N]);

end


function validateInitialParams(initialParams, transformType)
% Make sure the number initial parameters matches the transform's requirements.

expectedNumParams = getNumberOfRegistrationParams(transformType);

iptassert(numel(initialParams) == expectedNumParams, ...
          'images:imregister:badInitialParams', ...
          numel(initialParams), ...
          expectedNumParams)

end


function optimConfig = setOptimScales(optimConfig, transformType,fixed_size)

otherScale = 1.0;

% Use the diagonal of the fixed image as the scale factor for translation
% in each dimension.
maxTranslation = hypot(fixed_size(1),fixed_size(2));
translationScale = otherScale/maxTranslation;

switch (transformType)
    case 'affine'
        
        optimConfig.Scales = [otherScale, otherScale, otherScale, ...
            otherScale, translationScale, translationScale];
        
    case 'similarity'
               
        optimConfig.Scales = [otherScale, otherScale,...
            translationScale, translationScale];
        
    case 'rigid'
       
          optimConfig.Scales = [otherScale,translationScale, translationScale];
        
    case 'translation'
        
        optimConfig.Scales = [1, 1];
        
    otherwise
        
        iptassert(false, ...
                  'images:imregister:badTransformType', transformType)
        
end

end


function num = getNumberOfRegistrationParams(transformationType)
%getNumberOfRegistrationParams  Number of parameters required for transformation.

% Make an initial parameters vector for this transformation type.
params = computeInitialRegParams(transformationType, [0 0]);

% The number of registration parameters is the length of this
% parameter vector.
num = numel(params);

end


function initialParams = computeInitialRegParams(transformType, ...
                                                 translationVector)
% Compute initial transformation parameters.
%
% Currently this corresponds to a crude attempt to align the images
% via pure trasnlation along with the assumption that any (potential)
% rotation is around the center of the image, and that there's no
% rotation or shear.

xoffset = translationVector(1);
yoffset = translationVector(2);

switch (transformType)
    case 'affine'
        
        initialParams = [1, 0, 0, 1, yoffset, xoffset];
        
    case 'similarity'
        
        initialParams = [1, 0, yoffset xoffset];
        
    case 'rigid'
        
        initialParams = [0, yoffset, xoffset];
        
        
    case 'translation'
        
        initialParams = [yoffset xoffset];
        
    otherwise
        
        iptassert(false, ...
                  'images:imregister:badTransformType', transformType)
        
end

end


function validatePyramidLevels(fixed,moving,numLevels)

requiredPixelsPerDim = 4.^(numLevels-1);

fixedTooSmallToPyramid  = any(size(fixed) < requiredPixelsPerDim);
movingTooSmallToPyramid = any(size(moving) < requiredPixelsPerDim);

if fixedTooSmallToPyramid || movingTooSmallToPyramid
    % Convert dims to strings, since they can be large enough to overflow
    % into a floating point type.
    error(message('images:imregister:tooSmallToPyramid', ...
                  sprintf('%d', requiredPixelsPerDim), ...
                  sprintf('%d', requiredPixelsPerDim), ...
                  numLevels));
end

end

function vec = findtranslation(A,B)
%FINDTRANSLATION Find translation vector.
%   VEC = FINDTRANSLATION(A,B) finds the translation vector between
%   images A and B. VEC = [tx ty] where tx and ty specify the number of pixels
%   needed to shift image A to bring it into alignment with image B.

% Copyright 2011 The MathWorks, Inc.

narginchk(2,2)

% Align the geometric centers of the two images.
[rowsA,colsA,~] = size(A);
[rowsB,colsB,~] = size(B);

vec = [(rowsB - rowsA), (colsB - colsA)] ./ 2;
end