(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}maplet/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".maplet/i\u{0a}"))))
; ^\d{4}\/\d{1,2}\/\d{1,2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /(\u{19}\u{00}|\u{00}\x5C)\u{00}n\u{00}w\u{00}d\u{00}b\u{00}l\u{00}i\u{00}b\u{00}\.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{19}\u{00}") (str.to_re "\u{00}\u{5c}")) (str.to_re "\u{00}n\u{00}w\u{00}d\u{00}b\u{00}l\u{00}i\u{00}b\u{00}.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i\u{0a}"))))
; connection\sHost\u{3a}Subject\x3A\.bmp
(assert (str.in_re X (re.++ (str.to_re "connection") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:Subject:.bmp\u{0a}"))))
; ^\d*(\.\d*)$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (str.to_re "\u{0a}.") (re.* (re.range "0" "9"))))))
(check-sat)
