(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([0-9]{2,4})([-\s\/]{0,1})([0-9]{4,8}))?$
(assert (not (str.in_re X (re.++ (re.opt (re.++ ((_ re.loop 2 4) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re "/") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 8) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^[0-9+]{5}-[0-9+]{7}-[0-9]{1}$
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (re.range "0" "9") (str.to_re "+"))) (str.to_re "-") ((_ re.loop 7 7) (re.union (re.range "0" "9") (str.to_re "+"))) (str.to_re "-") ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}3gp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".3gp/i\u{0a}"))))
; /\u{3d}\u{0a}$/P
(assert (str.in_re X (str.to_re "/=\u{0a}/P\u{0a}")))
; \x2Fpagead\x2Fads\?waitingisDownload
(assert (not (str.in_re X (str.to_re "/pagead/ads?waitingisDownload\u{0a}"))))
(check-sat)
