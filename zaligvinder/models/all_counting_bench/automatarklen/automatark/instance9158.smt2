(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}mkv/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mkv/i\u{0a}"))))
; <\/?(tag1|tag2)[^>]*\/?>
(assert (str.in_re X (re.++ (str.to_re "<") (re.opt (str.to_re "/")) (re.* (re.comp (str.to_re ">"))) (re.opt (str.to_re "/")) (str.to_re ">\u{0a}tag") (re.union (str.to_re "1") (str.to_re "2")))))
; ^([1-9]|0[1-9]|1[0-2]):([0-5][0-9])$
(assert (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re ":\u{0a}") (re.range "0" "5") (re.range "0" "9"))))
; /^GET\s\/[a-z]{5}\.php\?id=[A-Z0-9]{18}\sHTTP\/1\.[0-1]\r\n/
(assert (str.in_re X (re.++ (str.to_re "/GET") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/") ((_ re.loop 5 5) (re.range "a" "z")) (str.to_re ".php?id=") ((_ re.loop 18 18) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "HTTP/1.") (re.range "0" "1") (str.to_re "\u{0d}\u{0a}/\u{0a}"))))
; /^\d+O\d+\.jsp\?[a-z0-9\u{3d}\u{2b}\u{2f}]{20}/iR
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re "O") (re.+ (re.range "0" "9")) (str.to_re ".jsp?") ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "=") (str.to_re "+") (str.to_re "/"))) (str.to_re "/iR\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
