(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; FTP\s+\x2FNFO\x2CRegistered\s+Server\s+www\x2Einternet-optimizer\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "FTP") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/NFO,Registered") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Server") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.internet-optimizer.com\u{0a}")))))
; /\u{2e}gni([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.gni") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ([0-9]{6}|[0-9]{3}\s[0-9]{3})
(assert (str.in_re X (re.++ (re.union ((_ re.loop 6 6) (re.range "0" "9")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; Host\x3A.*www\u{2e}2-seek\u{2e}com\u{2f}search
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "www.2-seek.com/search\u{0a}"))))
; www\x2Eonlinecasinoextra\x2EcomWindows
(assert (not (str.in_re X (str.to_re "www.onlinecasinoextra.comWindows\u{0a}"))))
(check-sat)
