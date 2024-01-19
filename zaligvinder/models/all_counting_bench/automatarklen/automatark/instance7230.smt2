(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; pass=Referer\x3ASurveillance
(assert (str.in_re X (str.to_re "pass=Referer:Surveillance\u{13}\u{0a}")))
; (ISBN[-]*(1[03])*[ ]*(: ){0,1})*(([0-9Xx][- ]*){13}|([0-9Xx][- ]*){10})
(assert (not (str.in_re X (re.++ (re.* (re.++ (str.to_re "ISBN") (re.* (str.to_re "-")) (re.* (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "3")))) (re.* (str.to_re " ")) (re.opt (str.to_re ": ")))) (re.union ((_ re.loop 13 13) (re.++ (re.union (re.range "0" "9") (str.to_re "X") (str.to_re "x")) (re.* (re.union (str.to_re "-") (str.to_re " "))))) ((_ re.loop 10 10) (re.++ (re.union (re.range "0" "9") (str.to_re "X") (str.to_re "x")) (re.* (re.union (str.to_re "-") (str.to_re " ")))))) (str.to_re "\u{0a}")))))
; [A-Za-z]+
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}"))))
; ^(\d{1,3}'(\d{3}')*\d{3}(\.\d{1,3})?|\d{1,3}(\.\d{3})?)$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "'") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "'"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))))) (str.to_re "\u{0a}"))))
; HXDownloadUser-Agent\x3AanswerDeletingCookieReferer\x3A
(assert (not (str.in_re X (str.to_re "HXDownloadUser-Agent:answerDeletingCookieReferer:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
