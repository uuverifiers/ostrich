(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\.thecommunicator\.net[^\n\r]*iufilfwulmfi\u{2f}riuf\.lio
(assert (not (str.in_re X (re.++ (str.to_re "www.thecommunicator.net") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "iufilfwulmfi/riuf.lio\u{0a}")))))
; (http(s?)://|[a-zA-Z0-9\-]+\.)[a-zA-Z0-9/~\-]+\.[a-zA-Z0-9/~\-_,&\?\.;]+[^\.,\s<]
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "http") (re.opt (str.to_re "s")) (str.to_re "://")) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re "."))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "/") (str.to_re "~") (str.to_re "-"))) (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "/") (str.to_re "~") (str.to_re "-") (str.to_re "_") (str.to_re ",") (str.to_re "&") (str.to_re "?") (str.to_re ".") (str.to_re ";"))) (re.union (str.to_re ".") (str.to_re ",") (str.to_re "<") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))
; DA\dwww\x2Ee-finder\x2Ecc.*User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "DA") (re.range "0" "9") (str.to_re "www.e-finder.cc") (re.* re.allchar) (str.to_re "User-Agent:\u{0a}")))))
; /\u{2f}n\.php\?h=[a-zA-Z0-9]*?\&s=[a-zA-Z0-9]{1,5}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//n.php?h=") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "&s=") ((_ re.loop 1 5) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}"))))
; ^R(\d){8}
(assert (str.in_re X (re.++ (str.to_re "R") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
