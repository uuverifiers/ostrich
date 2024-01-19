(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; tb\x2Efreeprod\x2Ecom\s+Web\.fcgiclvompycem\u{2f}cen\.vcn
(assert (str.in_re X (re.++ (str.to_re "tb.freeprod.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Web.fcgiclvompycem/cen.vcn\u{0a}"))))
; ^((\d|\d\d|[0-1]\d\d|2[0-4]\d|25[0-5])\.(\d|\d\d|[0-1]\d\d|2[0-4]\d|25[0-5])\.(\d|\d\d|[0-1]\d\d|2[0-4]\d|25[0-5])\.(\d|\d\d|[0-1]\d\d|2[0-4]\d|25[0-5]))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "1") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re ".") (re.union (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "1") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re ".") (re.union (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "1") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re ".") (re.union (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "1") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))))))
; Host\x3A\s+User-Agent\x3A\s+Host\x3ADesktopBlade
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:DesktopBlade\u{0a}"))))
; From\x3A.*Host\x3A\s+Downloadfowclxccdxn\u{2f}uxwn\.ddy
(assert (not (str.in_re X (re.++ (str.to_re "From:") (re.* re.allchar) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Downloadfowclxccdxn/uxwn.ddy\u{0a}")))))
; /\u{0a}Array\u{0a}\u{28}\u{0a}\u{20}{4}\u{5b}[a-z\d]{11}\u{5d}\u{20}\u{3d}\u{3e}\u{20}\d{16}\u{0a}\u{29}/i
(assert (str.in_re X (re.++ (str.to_re "/\u{0a}Array\u{0a}(\u{0a}") ((_ re.loop 4 4) (str.to_re " ")) (str.to_re "[") ((_ re.loop 11 11) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "] => ") ((_ re.loop 16 16) (re.range "0" "9")) (str.to_re "\u{0a})/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
