(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d|,)*\.?\d*$
(assert (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (str.to_re ","))) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}jpeg/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jpeg/i\u{0a}"))))
; ^([A-Z]{1,2}[0-9]{1,2}|[A-Z]{3}|[A-Z]{1,2}[0-9][A-Z])( |-)[0-9][A-Z]{2}
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) ((_ re.loop 1 2) (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "A" "Z")) (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) (re.range "0" "9") (re.range "A" "Z"))) (re.union (str.to_re " ") (str.to_re "-")) (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}"))))
; /(\u{19}\u{00}|\u{00}\x5C)\u{00}s\u{00}p\u{00}f\u{00}r\u{00}a\u{00}m\u{00}e\u{00}\.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{19}\u{00}") (str.to_re "\u{00}\u{5c}")) (str.to_re "\u{00}s\u{00}p\u{00}f\u{00}r\u{00}a\u{00}m\u{00}e\u{00}.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i\u{0a}")))))
(check-sat)
