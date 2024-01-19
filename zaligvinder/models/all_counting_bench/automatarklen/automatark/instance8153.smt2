(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; on\w+Host\x3AComputerKeylogger\x2EcomHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "on") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:ComputerKeylogger.comHost:User-Agent:\u{0a}")))))
; [^0-9]((\(?(\+420|00420)\)?( |-)?)?([0-9]{3} ?(([0-9]{3} ?[0-9]{3})|([0-9]{2} ?[0-9]{2} ?[0-9]{2})))|([0-9]{3}-(([0-9]{3}-[0-9]{3})|([0-9]{2}-[0-9]{2}-[0-9]{2}))))[^0-9|/]
(assert (str.in_re X (re.++ (re.range "0" "9") (re.union (re.++ (re.opt (re.++ (re.opt (str.to_re "(")) (re.union (str.to_re "+420") (str.to_re "00420")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))))) (re.union (re.range "0" "9") (str.to_re "|") (str.to_re "/")) (str.to_re "\u{0a}"))))
; Host\x3Aact=Host\u{3a}User-Agent\x3AUser-Agent\x3ALiteselect\x2FGet
(assert (str.in_re X (str.to_re "Host:act=Host:User-Agent:User-Agent:Liteselect/Get\u{0a}")))
; ((FI|HU|LU|MT|SI)-?)?[0-9]{8}
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "FI") (str.to_re "HU") (str.to_re "LU") (str.to_re "MT") (str.to_re "SI")) (re.opt (str.to_re "-")))) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
