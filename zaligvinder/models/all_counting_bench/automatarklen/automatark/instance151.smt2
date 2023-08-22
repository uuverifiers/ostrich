(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[1-9][0-9]{3}[ ]?(([a-rt-zA-RT-Z]{2})|([sS][^dasDAS]))$
(assert (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) (re.union ((_ re.loop 2 2) (re.union (re.range "a" "r") (re.range "t" "z") (re.range "A" "R") (re.range "T" "Z"))) (re.++ (re.union (str.to_re "s") (str.to_re "S")) (re.union (str.to_re "d") (str.to_re "a") (str.to_re "s") (str.to_re "D") (str.to_re "A") (str.to_re "S")))) (str.to_re "\u{0a}"))))
; Days\s+HWAE\s+Host\x3APortawww\.thecommunicator\.net
(assert (str.in_re X (re.++ (str.to_re "Days") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "HWAE") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Portawww.thecommunicator.net\u{0a}"))))
; ^(((ht|f)tp(s?))\://).*$
(assert (not (str.in_re X (re.++ (re.* re.allchar) (str.to_re "\u{0a}://") (re.union (str.to_re "ht") (str.to_re "f")) (str.to_re "tp") (re.opt (str.to_re "s"))))))
; /^\/cnt\.php\?id=\d+$/U
(assert (str.in_re X (re.++ (str.to_re "//cnt.php?id=") (re.+ (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
; /bincode=Wz[0-9A-Za-z\u{2b}\u{2f}]{32}\u{3d}{0,2}$/Um
(assert (not (str.in_re X (re.++ (str.to_re "/bincode=Wz") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "+") (str.to_re "/"))) ((_ re.loop 0 2) (str.to_re "=")) (str.to_re "/Um\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
