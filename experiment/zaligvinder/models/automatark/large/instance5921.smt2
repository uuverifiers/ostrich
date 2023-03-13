(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /pdf\.php\?pdf=[0-9A-F]+&type=\d+&o=[^&]+&b=/U
(assert (not (str.in_re X (re.++ (str.to_re "/pdf.php?pdf=") (re.+ (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "&type=") (re.+ (re.range "0" "9")) (str.to_re "&o=") (re.+ (re.comp (str.to_re "&"))) (str.to_re "&b=/U\u{0a}")))))
; /^GET \/\w+\/\d{5}\/[a-z]{4}\.php\?[a-z]{3}\x5Fid=[A-Za-z0-9+\/]{43}= HTTP\//
(assert (str.in_re X (re.++ (str.to_re "/GET /") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "a" "z")) (str.to_re ".php?") ((_ re.loop 3 3) (re.range "a" "z")) (str.to_re "_id=") ((_ re.loop 43 43) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) (str.to_re "= HTTP//\u{0a}"))))
(check-sat)
