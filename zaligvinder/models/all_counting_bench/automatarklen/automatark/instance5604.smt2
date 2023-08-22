(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((0[1-9])|(1[02]))/\d{2}
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (str.to_re "/") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /(USER|NICK)\u{20}BOSS\u{2d}[A-Z0-9\u{5b}\u{5d}\u{2d}]{15}/
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "USER") (str.to_re "NICK")) (str.to_re " BOSS-") ((_ re.loop 15 15) (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "[") (str.to_re "]") (str.to_re "-"))) (str.to_re "/\u{0a}"))))
; /filename=[^\n]*\u{2e}xls/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xls/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
