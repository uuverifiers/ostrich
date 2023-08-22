(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\s+User-Agent\x3AUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:User-Agent:\u{0a}"))))
; ^([1-9]([0-9])?)(\.(([0])?|([1-9])?|[1]([0-1])?)?)?$
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re ".") (re.opt (re.union (re.opt (str.to_re "0")) (re.opt (re.range "1" "9")) (re.++ (str.to_re "1") (re.opt (re.range "0" "1"))))))) (str.to_re "\u{0a}") (re.range "1" "9") (re.opt (re.range "0" "9")))))
; gpstool\u{2e}globaladserver\u{2e}comfriend_nickname=CIA-Notify-Tezt
(assert (str.in_re X (str.to_re "gpstool.globaladserver.comfriend_nickname=CIA-Notify-Tezt\u{0a}")))
; www\.thecommunicator\.net[^\n\r]*iufilfwulmfi\u{2f}riuf\.lio
(assert (not (str.in_re X (re.++ (str.to_re "www.thecommunicator.net") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "iufilfwulmfi/riuf.lio\u{0a}")))))
; ^0$|^[1-9][0-9]*$|^[1-9][0-9]{0,2}(,[0-9]{3})$
(assert (not (str.in_re X (re.union (str.to_re "0") (re.++ (re.range "1" "9") (re.* (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "\u{0a},") ((_ re.loop 3 3) (re.range "0" "9")))))))
(assert (> (str.len X) 10))
(check-sat)
