(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x7D\x7BTrojan\x3A\w+Host\x3Arprpgbnrppb\u{2f}ci
(assert (str.in_re X (re.++ (str.to_re "}{Trojan:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:rprpgbnrppb/ci\u{0a}"))))
; ^[^\s]+@[^\.][^\s]{1,}\.[A-Za-z]{2,10}$
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "@") (re.comp (str.to_re ".")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".") ((_ re.loop 2 10) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
; Toolbar\d+ServerLiteToolbardailywww\x2Ecameup\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Toolbar") (re.+ (re.range "0" "9")) (str.to_re "ServerLiteToolbardailywww.cameup.com\u{13}\u{0a}")))))
; is\s+lnzzlnbk\u{2f}pkrm\.fin\s+Host\x3A\x2Ftoolbar\x2Fsupremetb
(assert (str.in_re X (re.++ (str.to_re "is") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.fin") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:/toolbar/supremetb\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
