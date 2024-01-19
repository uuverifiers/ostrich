(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; fromMinixmlldap\x3A\x2F\x2F\x2Fbonzibuddy\x2Ftoolbar_domain_redirectUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "fromMinixmlldap:///bonzibuddy/toolbar_domain_redirectUser-Agent:\u{0a}"))))
; Host\x3A\u{2c}STATSTimeTotalpassword\x3B1\x3BOptix
(assert (not (str.in_re X (str.to_re "Host:,STATSTimeTotalpassword;1;Optix\u{0a}"))))
; Host\x3APortawww\.thecommunicator\.net
(assert (not (str.in_re X (str.to_re "Host:Portawww.thecommunicator.net\u{0a}"))))
; User-Agent\x3A\d+Desktop\sIDENTIFY666User-Agent\x3A\x5BStatic
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "Desktop") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "IDENTIFY666User-Agent:[Static\u{0a}"))))
; ^[0-9]{0,5}[ ]{0,1}[0-9]{0,6}$
(assert (not (str.in_re X (re.++ ((_ re.loop 0 5) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 0 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
