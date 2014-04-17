function iptassert(cond, msgID, varargin)
%iptassert  Throw an assertion if a condition is false.
%    IPTASSERT(COND, MSGID, VARARGIN) throws an assertion with the
%    message ID specified by MSGID if COND is false.  The extra
%    arguments to IPTASSERT are passed to the message object
%    constructor.
%
%    This function is a very thin wrapper around MATLAB's ASSERT
%    function, but it does not cause the creation of a message
%    object unless the condition was not satisfied, which is an
%    optimization over the behavior of ASSERT.

%   Copyright 2011 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2011/11/09 16:49:12 $

if (~cond)
  if (nargin > 2)
    assert(cond, message(msgID, varargin{:}))
  else
    assert(cond, message(msgID))
  end
end
