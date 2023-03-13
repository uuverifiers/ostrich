(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^Host:\s*?[a-f0-9]{63,64}\./Him
(assert (str.in_re X (re.++ (str.to_re "/Host:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 63 64) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "./Him\u{0a}"))))
; /^\/[a-f0-9]{8}\/[a-f0-9]{7,8}\/$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 7 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "//U\u{0a}"))))
; /^([0-9a-zA-Z]+|[a-zA-Z]:(\\(\w[\w ]*.*))+|\\(\\(\w[\w ]*.*))+)\.[0-9a-zA-Z]{1,3}$/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":") (re.+ (re.++ (str.to_re "\u{5c}") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* re.allchar)))) (re.++ (str.to_re "\u{5c}") (re.+ (re.++ (str.to_re "\u{5c}") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* re.allchar))))) (str.to_re ".") ((_ re.loop 1 3) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "/\u{0a}")))))
; \.exe\s+v2\x2E0\s+smrtshpr-cs-
(assert (str.in_re X (re.++ (str.to_re ".exe") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "v2.0") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "smrtshpr-cs-\u{13}\u{0a}"))))
; ^[1-9]\d?-\d{7}$
(assert (str.in_re X (re.++ (re.range "1" "9") (re.opt (re.range "0" "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
