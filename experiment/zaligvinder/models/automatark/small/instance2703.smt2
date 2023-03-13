(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; CD\x2F\.ico\x2FsLogearch195\.225\.
(assert (str.in_re X (str.to_re "CD/.ico/sLogearch195.225.\u{0a}")))
; ^[2-9][0-8]\d[2-9]\d{6}$
(assert (str.in_re X (re.++ (re.range "2" "9") (re.range "0" "8") (re.range "0" "9") (re.range "2" "9") ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[0-9]+(,[0-9]+)*$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.* (re.++ (str.to_re ",") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}por/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".por/i\u{0a}"))))
(check-sat)
