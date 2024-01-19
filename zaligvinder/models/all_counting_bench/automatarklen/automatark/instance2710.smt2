(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; sbRedirectionsHost\x3AHost\x3AUser-Agent\x3Ahotbar%3fwww\x2Einternetadvertisingcompany\x2Ebiz
(assert (str.in_re X (str.to_re "sbRedirections\u{1b}Host:Host:User-Agent:hotbar%3fwww.internetadvertisingcompany.biz\u{0a}")))
; \x3Cchat\x3EHost\x3Atid\x3D\x7B
(assert (not (str.in_re X (str.to_re "<chat>\u{1b}Host:tid={\u{0a}"))))
; ^(0|(\+)?([1-9]{1}[0-9]{0,3})|([1-5]{1}[0-9]{1,4}|[6]{1}([0-4]{1}[0-9]{3}|[5]{1}([0-4]{1}[0-9]{2}|[5]{1}([0-2]{1}[0-9]{1}|[3]{1}[0-5]{1})))))$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "0") (re.++ (re.opt (str.to_re "+")) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "5")) ((_ re.loop 1 4) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "6")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "4")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "5")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "4")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "5")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "2")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "3")) ((_ re.loop 1 1) (re.range "0" "5")))))))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
