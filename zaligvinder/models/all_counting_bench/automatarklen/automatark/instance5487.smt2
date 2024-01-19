(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Logger\w+searchreslt\dSubject\x3AHANDY\x2FrssScaner
(assert (str.in_re X (re.++ (str.to_re "Logger") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "searchreslt") (re.range "0" "9") (str.to_re "Subject:HANDY/rssScaner\u{0a}"))))
; /\/modules\/(n?\d|nu)\.swf$/U
(assert (str.in_re X (re.++ (str.to_re "//modules/") (re.union (re.++ (re.opt (str.to_re "n")) (re.range "0" "9")) (str.to_re "nu")) (str.to_re ".swf/U\u{0a}"))))
; SbAts\d+dcww\x2Edmcast\x2EcomdistID=
(assert (not (str.in_re X (re.++ (str.to_re "SbAts") (re.+ (re.range "0" "9")) (str.to_re "dcww.dmcast.comdistID=\u{0a}")))))
; ^(3[0-1]|2[0-9]|1[0-9]|0[1-9])(0[0-9]|1[0-9]|2[0-3])([0-5][0-9])\sUTC\s(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s[0-9]{2}$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "3") (re.range "0" "1")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "0") (re.range "1" "9"))) (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "UTC") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (str.to_re "Jan") (str.to_re "Feb") (str.to_re "Mar") (str.to_re "Apr") (str.to_re "May") (str.to_re "Jun") (str.to_re "Jul") (str.to_re "Aug") (str.to_re "Sep") (str.to_re "Oct") (str.to_re "Nov") (str.to_re "Dec")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}") (re.range "0" "5") (re.range "0" "9"))))
(assert (> (str.len X) 10))
(check-sat)
