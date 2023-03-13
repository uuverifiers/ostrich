(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; CMDLoginExciteSubject\x3Adownloadfile\u{2e}org
(assert (not (str.in_re X (str.to_re "CMDLoginExciteSubject:downloadfile.org\u{0a}"))))
; (^\+[0-9]{2}|^\+[0-9]{2}\(0\)|^\(\+[0-9]{2}\)\(0\)|^00[0-9]{2}|^0)([0-9]{9}$|[0-9\-\s]{10}$)
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "+") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "+") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "(0)")) (re.++ (str.to_re "(+") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")(0)")) (re.++ (str.to_re "00") ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "0")) (re.union ((_ re.loop 9 9) (re.range "0" "9")) ((_ re.loop 10 10) (re.union (re.range "0" "9") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "\u{0a}"))))
; [0-9]+
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
; (^[1]$)|(^[1]+\d*\.+\d*[1-5]$)
(assert (not (str.in_re X (re.union (str.to_re "1") (re.++ (str.to_re "\u{0a}") (re.+ (str.to_re "1")) (re.* (re.range "0" "9")) (re.+ (str.to_re ".")) (re.* (re.range "0" "9")) (re.range "1" "5"))))))
; /\/stat_svc\/$/U
(assert (str.in_re X (str.to_re "//stat_svc//U\u{0a}")))
(check-sat)
