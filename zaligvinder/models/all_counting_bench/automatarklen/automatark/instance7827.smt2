(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3ASpyxpsp2-Host\u{3a}Host\x3Awjpropqmlpohj\u{2f}loregister\.asp
(assert (not (str.in_re X (str.to_re "Host:Spyxpsp2-Host:Host:wjpropqmlpohj/loregister.asp\u{0a}"))))
; (((0[123456789]|10|11|12)(([1][9][0-9][0-9])|([2][0-9][0-9][0-9]))))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) (str.to_re "10") (str.to_re "11") (str.to_re "12")) (re.union (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9")))))))
; ^([0]?[1-9]|[1|2][0-9]|[3][0|1])[/]([0]?[1-9]|[1][0-2])[/]([0-9]{4}|[0-9]{2}) ([0-1][0-9]|[2][0-3]):([0-5][0-9])$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "|") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "|") (str.to_re "1")))) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re " ") (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":\u{0a}") (re.range "0" "5") (re.range "0" "9"))))
; style="[^"]*"|'[^']*'
(assert (str.in_re X (re.union (re.++ (str.to_re "style=\u{22}") (re.* (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{22}")) (re.++ (str.to_re "'") (re.* (re.comp (str.to_re "'"))) (str.to_re "'\u{0a}")))))
; www\x2Esogou\x2EcomUser-Agent\x3A
(assert (str.in_re X (str.to_re "www.sogou.comUser-Agent:\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
