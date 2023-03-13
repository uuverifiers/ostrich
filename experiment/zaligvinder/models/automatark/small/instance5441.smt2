(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\-?[0-9]*\.?[0-9]+$)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "-")) (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.+ (re.range "0" "9"))))))
; /filename=[^\n]*\u{2e}mov/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mov/i\u{0a}"))))
; ^([0-9a-fA-F])*$
(assert (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "\u{0a}"))))
; Host\x3A[^\n\r]*\x2Fbar_pl\x2Fshdoclc\.fcgi
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "/bar_pl/shdoclc.fcgi\u{0a}"))))
; /^\/\d{8,11}\/1[34]\d{8}\.pdf$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 8 11) (re.range "0" "9")) (str.to_re "/1") (re.union (str.to_re "3") (str.to_re "4")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re ".pdf/U\u{0a}"))))
(check-sat)
