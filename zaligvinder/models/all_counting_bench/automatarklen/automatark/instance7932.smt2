(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[^ \\/:*?""<>|]+([ ]+[^ \\/:*?""<>|]+)*$
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{5c}") (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (re.* (re.++ (re.+ (str.to_re " ")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{5c}") (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))))) (str.to_re "\u{0a}")))))
; (^(49030)[2-9](\d{10}$|\d{12,13}$))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}49030") (re.range "2" "9") (re.union ((_ re.loop 10 10) (re.range "0" "9")) ((_ re.loop 12 13) (re.range "0" "9")))))))
; /^\/\d{9,10}\/1\d{9}\.jar$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 9 10) (re.range "0" "9")) (str.to_re "/1") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re ".jar/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
