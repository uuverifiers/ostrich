(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <textarea(.|\n)*?>((.|\n)*?)</textarea>
(assert (not (str.in_re X (re.++ (str.to_re "<textarea") (re.* (re.union re.allchar (str.to_re "\u{0a}"))) (str.to_re ">") (re.* (re.union re.allchar (str.to_re "\u{0a}"))) (str.to_re "</textarea>\u{0a}")))))
; Host\x3A[^\n\r]*\x2Fbar_pl\x2Fshdoclc\.fcgi
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "/bar_pl/shdoclc.fcgi\u{0a}"))))
; ^(([0][1-9]|[1|2][0-9]|[3][0|1])[./-]([0][1-9]|[1][0-2])[./-]([0-9]{4})|(([0][1-9]|[1|2][0-9]|[3][0|1])[./-]([0][1-9]|[1][0-2])[./-]([0-9]{4}))[ ]([0|1][0-2])[:](([0-5][0-9]))([:](([0-5][0-9])))?)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "|") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "|") (str.to_re "1")))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re " :") (re.opt (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "|") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "|") (str.to_re "1")))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re "0") (str.to_re "|") (str.to_re "1")) (re.range "0" "2") (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
