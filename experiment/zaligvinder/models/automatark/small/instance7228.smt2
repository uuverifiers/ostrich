(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Subject\u{3a}reportGatorNavExcel
(assert (not (str.in_re X (str.to_re "Subject:reportGatorNavExcel\u{0a}"))))
; ^((\+){1}91){1}[1-9]{1}[0-9]{9}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.++ ((_ re.loop 1 1) (str.to_re "+")) (str.to_re "91"))) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; HXLogOnlyDaemonactivityIterenetFrom\x3AClass
(assert (not (str.in_re X (str.to_re "HXLogOnlyDaemonactivityIterenetFrom:Class\u{0a}"))))
; DmInf\x5E\s+Contactfrom=GhostVoiceServerUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "DmInf^") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Contactfrom=GhostVoiceServerUser-Agent:\u{0a}")))))
; (^\d*\.?\d*[0-9]+\d*$)|(^[0-9]+\d*\.\d*$)
(assert (not (str.in_re X (re.union (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (re.+ (re.range "0" "9")) (re.* (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.+ (re.range "0" "9")) (re.* (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9")))))))
(check-sat)
