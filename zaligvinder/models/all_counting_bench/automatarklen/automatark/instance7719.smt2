(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^GET\u{20}\/plus\u{2e}asp\?[^\r\n]*?query=[a-z0-9+\/]{2,40}@{0,2}/i
(assert (not (str.in_re X (re.++ (str.to_re "/GET /plus.asp?") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "query=") ((_ re.loop 2 40) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) ((_ re.loop 0 2) (str.to_re "@")) (str.to_re "/i\u{0a}")))))
; /\u{2e}ogg([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.ogg") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; \.exe\s+v2\x2E0\s+smrtshpr-cs-
(assert (not (str.in_re X (re.++ (str.to_re ".exe") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "v2.0") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "smrtshpr-cs-\u{13}\u{0a}")))))
; www\x2Eyok\x2Ecom\s+jupitersatellites\x2Ebiz.*User-Agent\x3Aclvompycem\u{2f}cen\.vcn
(assert (not (str.in_re X (re.++ (str.to_re "www.yok.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "jupitersatellites.biz") (re.* re.allchar) (str.to_re "User-Agent:clvompycem/cen.vcn\u{0a}")))))
; /\u{b6}\u{b6}\u{ff}\u{ff}\u{ff}\u{ff}$/
(assert (str.in_re X (str.to_re "/\u{b6}\u{b6}\u{ff}\u{ff}\u{ff}\u{ff}/\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
