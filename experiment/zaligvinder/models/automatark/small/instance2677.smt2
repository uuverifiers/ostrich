(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(user=([a-z0-9]+,)*(([a-z0-9]+){1});)?(group=([a-z0-9]+,)*(([a-z0-9]+){1});)?(level=[0-9]+;)?$
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "user=") (re.* (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ","))) ((_ re.loop 1 1) (re.+ (re.union (re.range "a" "z") (re.range "0" "9")))) (str.to_re ";"))) (re.opt (re.++ (str.to_re "group=") (re.* (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ","))) ((_ re.loop 1 1) (re.+ (re.union (re.range "a" "z") (re.range "0" "9")))) (str.to_re ";"))) (re.opt (re.++ (str.to_re "level=") (re.+ (re.range "0" "9")) (str.to_re ";"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}vwr/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".vwr/i\u{0a}")))))
; Host\u{3a}\dgpstool\u{2e}globaladserver\u{2e}comdesksearch\.dropspam\.com
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "gpstool.globaladserver.comdesksearch.dropspam.com\u{0a}"))))
; ^(\d{4})-((0[1-9])|(1[0-2]))-(0[1-9]|[12][0-9]|3[01])$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "\u{0a}"))))
; (^\b\d+-\d+$\b)|(^\b\d+$\b)
(assert (not (str.in_re X (re.union (re.++ (re.+ (re.range "0" "9")) (str.to_re "-") (re.+ (re.range "0" "9"))) (re.++ (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(check-sat)
