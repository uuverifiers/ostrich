(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\w+www.*ToolbartheServer\x3Awww\x2Esearchreslt\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www") (re.* re.allchar) (str.to_re "ToolbartheServer:www.searchreslt.com\u{0a}")))))
; ^07([\d]{3})[(\D\s)]?[\d]{3}[(\D\s)]?[\d]{3}$
(assert (not (str.in_re X (re.++ (str.to_re "07") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "(") (re.comp (re.range "0" "9")) (str.to_re ")") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "(") (re.comp (re.range "0" "9")) (str.to_re ")") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
