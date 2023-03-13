(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Subject\u{3a}HostYWRtaW46cGFzc3dvcmQ
(assert (not (str.in_re X (str.to_re "Subject:HostYWRtaW46cGFzc3dvcmQ\u{0a}"))))
; ^100$|^\d{0,2}(\.\d{1,2})? *%?$
(assert (str.in_re X (re.union (str.to_re "100") (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (re.* (str.to_re " ")) (re.opt (str.to_re "%")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}vap/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".vap/i\u{0a}"))))
(check-sat)
