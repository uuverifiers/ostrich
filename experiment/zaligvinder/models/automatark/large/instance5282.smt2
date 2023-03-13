(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}asx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".asx/i\u{0a}")))))
; ([0-0]{1}[1-9]{1}[0-9]{9})|[1-9]{1}[0-9]{9}
(assert (str.in_re X (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "0")) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 9 9) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; (^1300\d{6}$)|(^1800|1900|1902\d{6}$)|(^0[2|3|7|8]{1}[0-9]{8}$)|(^13\d{4}$)|(^04\d{2,3}\d{6}$)
(assert (not (str.in_re X (re.union (re.++ (str.to_re "1300") ((_ re.loop 6 6) (re.range "0" "9"))) (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.union (str.to_re "2") (str.to_re "|") (str.to_re "3") (str.to_re "7") (str.to_re "8"))) ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ (str.to_re "13") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}04") ((_ re.loop 2 3) (re.range "0" "9")) ((_ re.loop 6 6) (re.range "0" "9"))) (str.to_re "1800") (str.to_re "1900") (re.++ (str.to_re "1902") ((_ re.loop 6 6) (re.range "0" "9")))))))
; PortweatherX-Mailer\u{3a}User-Agent\x3AToolbar
(assert (str.in_re X (str.to_re "PortweatherX-Mailer:\u{13}User-Agent:Toolbar\u{0a}")))
(check-sat)
