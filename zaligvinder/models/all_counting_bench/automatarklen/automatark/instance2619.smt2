(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /(\u{19}\u{00}|\u{00}\x5C)\u{00}s\u{00}p\u{00}f\u{00}r\u{00}a\u{00}m\u{00}e\u{00}\.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{19}\u{00}") (str.to_re "\u{00}\u{5c}")) (str.to_re "\u{00}s\u{00}p\u{00}f\u{00}r\u{00}a\u{00}m\u{00}e\u{00}.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i\u{0a}")))))
; ^[1-9][0-9]{0,2}$
(assert (not (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\u{2e}csd([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.csd") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; (^[0]{1}$|^[-]?[1-9]{1}\d*$)
(assert (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (str.to_re "0")) (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
