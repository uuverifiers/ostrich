(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[a-f0-9]{32}\.eot$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".eot/U\u{0a}")))))
; www\x2Esearchreslt\x2Ecom
(assert (not (str.in_re X (str.to_re "www.searchreslt.com\u{0a}"))))
; www\x2Eezula\x2Ecom.*com[^\n\r]*SpyBuddy
(assert (not (str.in_re X (re.++ (str.to_re "www.ezula.com") (re.* re.allchar) (str.to_re "com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "SpyBuddy\u{0a}")))))
; ^(-?[1-9](\.\d+)?)((\s?[X*]\s?10[E^]([+-]?\d+))|(E([+-]?\d+)))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "X") (str.to_re "*")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "10") (re.union (str.to_re "E") (str.to_re "^")) (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.+ (re.range "0" "9"))) (re.++ (str.to_re "E") (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}") (re.opt (str.to_re "-")) (re.range "1" "9") (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))))))
; /filename=[^\n]*\u{2e}xsl/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xsl/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
