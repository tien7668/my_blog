module TT
  # Base error
  class Error < StandardError
    CODE_MAP =
    { BAD_REQUEST: 400,
      UNAUTHENTICATED: 1000,
      RECORD_NOT_FOUND: 1001,
      RECORD_EXIST: 1002,
      RECORD_CANNOT_SAVE: 1003,
      PASSWORD_NOT_VALID: 1004,
      PASSWORD_NOT_MATCH: 1005,
      RESET_PSW_NOT_ALLOWED: 1006,
      WORKER_PHONE_VERIFIED: 2000,
      WORKER_OTP_EXPIRED: 2001,
      WORKER_INACTIVE: 2002,
      WORKER_UNVERIFIED_INACTIVE: 2003,
      WORKER_VERIFIED_INACTIVE: 2004,
    }
    def initialize(name, message)
      @name = name
      @message = message
    end

    def message
      @message
    end

    def name
      @name
    end
  end
end
