(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Elookster\x2Enet\s+Host\x3ADesktopBlade
(assert (not (str.in_re X (re.++ (str.to_re "www.lookster.net") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:DesktopBlade\u{0a}")))))
; www\x2Erichfind\x2Ecom\d+UI2
(assert (str.in_re X (re.++ (str.to_re "www.richfind.com") (re.+ (re.range "0" "9")) (str.to_re "UI2\u{0a}"))))
; ^\b\d{2,3}-*\d{7}\b$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (re.* (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /NICK A\[New\|(98|Me|NT4.0|2000|XP|Serv2003|Vis|7|Unk)\|x(86|64)\|[A-Z\-]{1,2}\|[0-9]{1,4}\]/
(assert (str.in_re X (re.++ (str.to_re "/NICK A[New|") (re.union (str.to_re "98") (str.to_re "Me") (re.++ (str.to_re "NT4") re.allchar (str.to_re "0")) (str.to_re "2000") (str.to_re "XP") (str.to_re "Serv2003") (str.to_re "Vis") (str.to_re "7") (str.to_re "Unk")) (str.to_re "|x") (re.union (str.to_re "86") (str.to_re "64")) (str.to_re "|") ((_ re.loop 1 2) (re.union (re.range "A" "Z") (str.to_re "-"))) (str.to_re "|") ((_ re.loop 1 4) (re.range "0" "9")) (str.to_re "]/\u{0a}"))))
; /filename=[^\n]*\u{2e}pfm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pfm/i\u{0a}")))))
(check-sat)
