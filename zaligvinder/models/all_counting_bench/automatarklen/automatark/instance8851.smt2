(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/se\/[a-f0-9]{100,200}\/[a-f0-9]{6,9}\/[A-Z0-9_]{4,200}\.com/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//se/") ((_ re.loop 100 200) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 6 9) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 4 200) (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (str.to_re ".com/Ui\u{0a}")))))
; Host\u{3a}.*ver\dRobert\dDmInf\x5EinfoSimpsonUser-Agent\x3AClientwww\x2Einternet-optimizer\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "ver") (re.range "0" "9") (str.to_re "Robert") (re.range "0" "9") (str.to_re "DmInf^infoSimpsonUser-Agent:Clientwww.internet-optimizer.com\u{0a}")))))
; ^(((([1]?\d)?\d|2[0-4]\d|25[0-5])\.){3}(([1]?\d)?\d|2[0-4]\d|25[0-5]))|([\da-fA-F]{1,4}(\:[\da-fA-F]{1,4}){7})|(([\da-fA-F]{1,4}:){0,5}::([\da-fA-F]{1,4}:){0,5}[\da-fA-F]{1,4})$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 3 3) (re.++ (re.union (re.++ (re.opt (re.++ (re.opt (str.to_re "1")) (re.range "0" "9"))) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re "."))) (re.union (re.++ (re.opt (re.++ (re.opt (str.to_re "1")) (re.range "0" "9"))) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")))) (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) ((_ re.loop 7 7) (re.++ (str.to_re ":") ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F")))))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 0 5) (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re ":"))) (str.to_re "::") ((_ re.loop 0 5) (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re ":"))) ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))))))))
(assert (> (str.len X) 10))
(check-sat)
