(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^number=[0-9A-F]{32}$/mC
(assert (str.in_re X (re.++ (str.to_re "/number=") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/mC\u{0a}"))))
; /filename=[^\n]*\u{2e}dbp/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dbp/i\u{0a}")))))
(check-sat)
