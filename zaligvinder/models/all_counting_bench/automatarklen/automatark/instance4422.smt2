(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\d{5}\x2D\d{3}$)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")))))
; <table>(<tr>((<td>([A-Za-z0-9])*</td>)+)</tr>)*</table>
(assert (str.in_re X (re.++ (str.to_re "<table>") (re.* (re.++ (str.to_re "<tr>") (re.+ (re.++ (str.to_re "<td>") (re.* (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "</td>"))) (str.to_re "</tr>"))) (str.to_re "</table>\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
