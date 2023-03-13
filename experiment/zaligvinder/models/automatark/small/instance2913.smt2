(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9])(\s{0,1})([AM|PM|am|pm]{2,2})$)|(^([0-9]|[1][0-9]|[2][0-3])(\s{0,1})([AM|PM|am|pm]{2,2})$)
(assert (not (str.in_re X (re.union (re.++ (re.union (re.range "0" "9") (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "M") (str.to_re "|") (str.to_re "P") (str.to_re "a") (str.to_re "m") (str.to_re "p"))) (re.range "0" "5") (re.range "0" "9")) (re.++ (str.to_re "\u{0a}") (re.union (re.range "0" "9") (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "M") (str.to_re "|") (str.to_re "P") (str.to_re "a") (str.to_re "m") (str.to_re "p"))))))))
; <table>(<tr>((<td>([A-Za-z0-9])*</td>)+)</tr>)*</table>
(assert (not (str.in_re X (re.++ (str.to_re "<table>") (re.* (re.++ (str.to_re "<tr>") (re.+ (re.++ (str.to_re "<td>") (re.* (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "</td>"))) (str.to_re "</tr>"))) (str.to_re "</table>\u{0a}")))))
; /[A-F0-9]{8}(-[A-F0-9]{4}){3}-[A-F0-9]{12}.wipe$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "A" "F") (re.range "0" "9"))) ((_ re.loop 3 3) (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "F") (re.range "0" "9"))))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "A" "F") (re.range "0" "9"))) re.allchar (str.to_re "wipe/Ui\u{0a}")))))
; www\x2Esnap\x2Ecom\w+FTX-Mailer\x3AfromReferer\x3Asearch\u{2e}conduit\u{2e}com
(assert (not (str.in_re X (re.++ (str.to_re "www.snap.com") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "FTX-Mailer:\u{13}fromReferer:search.conduit.com\u{0a}")))))
(check-sat)
