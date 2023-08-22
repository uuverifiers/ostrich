(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[0-9]{5}\.jar$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re ".jar/U\u{0a}")))))
; /filename=[^\n]*\u{2e}hpj/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".hpj/i\u{0a}")))))
; ^(|(0\d)|(1[0-2])):(([0-5]\d)):(([0-5]\d))\s([AP]M)$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "::") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}") (re.range "0" "5") (re.range "0" "9") (re.range "0" "5") (re.range "0" "9") (re.union (str.to_re "A") (str.to_re "P")) (str.to_re "M"))))
; ^1?[-\. ]?(\(\d{3}\)?[-\. ]?|\d{3}?[-\. ]?)?\d{3}?[-\. ]?\d{4}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "1")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) (re.opt (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ")))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ")))))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; (-?(\d*\.\d{1}?\d*|\d{1,}))
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "-")) (re.union (re.++ (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9")) (re.* (re.range "0" "9"))) (re.+ (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
