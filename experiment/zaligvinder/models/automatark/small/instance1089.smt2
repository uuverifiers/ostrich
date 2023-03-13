(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \.txt$
(assert (not (str.in_re X (str.to_re ".txt\u{0a}"))))
; ([A-Za-z0-9]+:\/\/)?([a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*)?(\/|(\/([A-Za-z0-9\:@!\$&'\(\}\*\+\-_,;=~\.]+|(%[A-F0-9]{2})+))*)(\?[A-Za-z0-9]+=[A-Za-z0-9]+(&[A-Za-z0-9]+=[A-Za-z0-9]+)*)?
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "://"))) (re.opt (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))))) (re.union (str.to_re "/") (re.* (re.++ (str.to_re "/") (re.union (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re ":") (str.to_re "@") (str.to_re "!") (str.to_re "$") (str.to_re "&") (str.to_re "'") (str.to_re "(") (str.to_re "}") (str.to_re "*") (str.to_re "+") (str.to_re "-") (str.to_re "_") (str.to_re ",") (str.to_re ";") (str.to_re "=") (str.to_re "~") (str.to_re "."))) (re.+ (re.++ (str.to_re "%") ((_ re.loop 2 2) (re.union (re.range "A" "F") (re.range "0" "9"))))))))) (re.opt (re.++ (str.to_re "?") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "=") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.* (re.++ (str.to_re "&") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "=") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))))))) (str.to_re "\u{0a}")))))
; ad\x2Emokead\x2Ecom\d+Spy\d+ZOMBIES\u{5f}HTTP\u{5f}GETearch\x2Eearthlinkwww\x2Epurityscan\x2EcomUser-Agent\u{3a}
(assert (str.in_re X (re.++ (str.to_re "ad.mokead.com") (re.+ (re.range "0" "9")) (str.to_re "Spy") (re.+ (re.range "0" "9")) (str.to_re "ZOMBIES_HTTP_GETearch.earthlinkwww.purityscan.comUser-Agent:\u{0a}"))))
; e2give\.com.*Login\s+adfsgecoiwnf\u{23}\u{23}\u{23}\u{23}User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "e2give.com") (re.* re.allchar) (str.to_re "Login") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "adfsgecoiwnf\u{1b}####User-Agent:\u{0a}")))))
; 3A\s+URLBlazeHost\x3Atrackhjhgquqssq\u{2f}pjm
(assert (not (str.in_re X (re.++ (str.to_re "3A") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "URLBlazeHost:trackhjhgquqssq/pjm\u{0a}")))))
(check-sat)
