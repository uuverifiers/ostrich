(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}mks/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mks/i\u{0a}")))))
; ^(0\.|([1-9]([0-9]+)?)\.){3}(0|([1-9]([0-9]+)?)){1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (str.to_re "0.") (re.++ (str.to_re ".") (re.range "1" "9") (re.opt (re.+ (re.range "0" "9")))))) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.++ (re.range "1" "9") (re.opt (re.+ (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
; $sPatternTablet = '/(Tablet|iPad|iPod)/';
(assert (str.in_re X (re.++ (str.to_re "sPatternTablet = '/") (re.union (str.to_re "Tablet") (str.to_re "iPad") (str.to_re "iPod")) (str.to_re "/';\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
