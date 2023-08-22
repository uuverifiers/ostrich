(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([1-9]|[0-2]\d|[3][0-1])\.([1-9]|[0]\d|[1][0-2])\.[2][0]\d{2})$|^(([1-9]|[0-2]\d|[3][0-1])\.([1-9]|[0]\d|[1][0-2])\.[2][0]\d{2}\s([1-9]|[0-1]\d|[2][0-3])\:[0-5]\d)$
(assert (not (str.in_re X (re.union (re.++ (re.union (re.range "1" "9") (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re ".") (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re ".20") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.union (re.range "1" "9") (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re ".") (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re ".20") ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.range "1" "9") (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))))))
; 32e3432ew+
(assert (not (str.in_re X (re.++ (str.to_re "32e3432e") (re.+ (str.to_re "w")) (str.to_re "\u{0a}")))))
; nick_name=CIA-Test\s+User-Agent\x3A\s+Downloadfowclxccdxn\u{2f}uxwn\.ddywww\x2Eeasymessage\x2Enet
(assert (str.in_re X (re.++ (str.to_re "nick_name=CIA-Test") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Downloadfowclxccdxn/uxwn.ddywww.easymessage.net\u{0a}"))))
; ^((([\(]?[2-9]{1}[0-9]{2}[\)]?)|([2-9]{1}[0-9]{2}\.?)){1}[ ]?[2-9]{1}[0-9]{2}[\-\.]{1}[0-9]{4})([ ]?[xX]{1}[ ]?[0-9]{3,4})?$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re " ")) ((_ re.loop 1 1) (re.union (str.to_re "x") (str.to_re "X"))) (re.opt (str.to_re " ")) ((_ re.loop 3 4) (re.range "0" "9")))) (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.union (re.++ (re.opt (str.to_re "(")) ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re ")"))) (re.++ ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "."))))) (re.opt (str.to_re " ")) ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re "."))) ((_ re.loop 4 4) (re.range "0" "9")))))
; ^[1-9]\d$
(assert (not (str.in_re X (re.++ (re.range "1" "9") (re.range "0" "9") (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
