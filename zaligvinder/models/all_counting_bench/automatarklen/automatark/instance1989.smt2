(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /(\u{19}\u{00}|\u{00}\x5C)\u{00}s\u{00}p\u{00}f\u{00}r\u{00}a\u{00}m\u{00}e\u{00}\.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{19}\u{00}") (str.to_re "\u{00}\u{5c}")) (str.to_re "\u{00}s\u{00}p\u{00}f\u{00}r\u{00}a\u{00}m\u{00}e\u{00}.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i\u{0a}"))))
; /^Host\u{3a}[^\u{0d}\u{0a}]+\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\u{3a}\d{1,5}\u{0d}?$/mi
(assert (str.in_re X (re.++ (str.to_re "/Host:") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")) (re.opt (str.to_re "\u{0d}")) (str.to_re "/mi\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
