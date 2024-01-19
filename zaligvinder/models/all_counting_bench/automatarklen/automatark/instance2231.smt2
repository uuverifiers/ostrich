(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /HTTP\/1.[01]\r\nUser\u{2d}Agent\u{3a}\u{20}[ -~]+\r\nHost\u{3a}\u{20}[a-z0-9\u{2d}\u{2e}]+\.info\r\n/
(assert (not (str.in_re X (re.++ (str.to_re "/HTTP/1") re.allchar (re.union (str.to_re "0") (str.to_re "1")) (str.to_re "\u{0d}\u{0a}User-Agent: ") (re.+ (re.range " " "~")) (str.to_re "\u{0d}\u{0a}Host: ") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".info\u{0d}\u{0a}/\u{0a}")))))
; ^.+\@.+\..+$
(assert (str.in_re X (re.++ (re.+ re.allchar) (str.to_re "@") (re.+ re.allchar) (str.to_re ".") (re.+ re.allchar) (str.to_re "\u{0a}"))))
; www\u{2e}2-seek\u{2e}com\u{2f}search\s+TPSystem
(assert (not (str.in_re X (re.++ (str.to_re "www.2-seek.com/search") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "TPSystem\u{0a}")))))
; ^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 2 2) (re.range "1" "9")) (re.++ (re.range "0" "9") (re.range "1" "9")) (re.++ (re.range "1" "9") (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; [0-7]+
(assert (str.in_re X (re.++ (re.+ (re.range "0" "7")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
