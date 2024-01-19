(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}\s+Agentbody=\u{25}21\u{25}21\u{25}21OptixSubject\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Agentbody=%21%21%21Optix\u{13}Subject:\u{0a}")))))
; ^([0-9]{2})(00[1-9]|0[1-9][0-9]|[1-2][0-9][0-9]|3[0-5][0-9]|36[0-6])$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.union (re.++ (str.to_re "00") (re.range "1" "9")) (re.++ (str.to_re "0") (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "5") (re.range "0" "9")) (re.++ (str.to_re "36") (re.range "0" "6"))) (str.to_re "\u{0a}"))))
; /Libs\/Starter(CmdExec|NetUtils|Rec|ScreenShots|Settings)\.py/
(assert (str.in_re X (re.++ (str.to_re "/Libs/Starter") (re.union (str.to_re "CmdExec") (str.to_re "NetUtils") (str.to_re "Rec") (str.to_re "ScreenShots") (str.to_re "Settings")) (str.to_re ".py/\u{0a}"))))
; User-Agent\x3AWeb-Mail
(assert (str.in_re X (str.to_re "User-Agent:Web-Mail\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
