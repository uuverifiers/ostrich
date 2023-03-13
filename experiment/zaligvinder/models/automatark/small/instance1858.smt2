(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; url\(['"]?([\w\d_\-\. ]+)['"]?\)
(assert (not (str.in_re X (re.++ (str.to_re "url(") (re.opt (re.union (str.to_re "'") (str.to_re "\u{22}"))) (re.+ (re.union (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re ".") (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (re.union (str.to_re "'") (str.to_re "\u{22}"))) (str.to_re ")\u{0a}")))))
; /NICK A\[New\|(98|Me|NT4.0|2000|XP|Serv2003|Vis|7|Unk)\|x(86|64)\|[A-Z\-]{1,2}\|[0-9]{1,4}\]/
(assert (not (str.in_re X (re.++ (str.to_re "/NICK A[New|") (re.union (str.to_re "98") (str.to_re "Me") (re.++ (str.to_re "NT4") re.allchar (str.to_re "0")) (str.to_re "2000") (str.to_re "XP") (str.to_re "Serv2003") (str.to_re "Vis") (str.to_re "7") (str.to_re "Unk")) (str.to_re "|x") (re.union (str.to_re "86") (str.to_re "64")) (str.to_re "|") ((_ re.loop 1 2) (re.union (re.range "A" "Z") (str.to_re "-"))) (str.to_re "|") ((_ re.loop 1 4) (re.range "0" "9")) (str.to_re "]/\u{0a}")))))
(check-sat)
