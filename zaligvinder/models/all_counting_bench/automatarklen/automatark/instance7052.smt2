(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b(((\S+)?)(@|mailto\:|(news|(ht|f)tp(s?))\://)\S+)\b
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (re.union (str.to_re "@") (str.to_re "mailto:") (re.++ (re.union (str.to_re "news") (re.++ (re.union (str.to_re "ht") (str.to_re "f")) (str.to_re "tp") (re.opt (str.to_re "s")))) (str.to_re "://"))) (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))))
; /filename=[^\n]*\u{2e}crx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".crx/i\u{0a}")))))
; ^(([0]?[0-5][0-9]|[0-9]):([0-5][0-9]))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "0" "5") (re.range "0" "9")) (re.range "0" "9")) (str.to_re ":") (re.range "0" "5") (re.range "0" "9")))))
; Host\u{3a}\x7D\x7BPort\x3Awww\x2Einstafinder\x2Ecom
(assert (not (str.in_re X (str.to_re "Host:}{Port:www.instafinder.com\u{0a}"))))
; /\u{2f}Type\u{2f}XRef\u{2f}W\u{5b}[^\u{5d}]*?\d{7,15}/smi
(assert (not (str.in_re X (re.++ (str.to_re "//Type/XRef/W[") (re.* (re.comp (str.to_re "]"))) ((_ re.loop 7 15) (re.range "0" "9")) (str.to_re "/smi\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
