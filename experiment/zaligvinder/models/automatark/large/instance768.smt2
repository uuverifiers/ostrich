(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; M\x2Ezip.*w3who.*\x2Fcgi\x2Flogurl\.cgiMyPostdll\x3FHOST\x3A
(assert (str.in_re X (re.++ (str.to_re "M.zip") (re.* re.allchar) (str.to_re "w3who") (re.* re.allchar) (str.to_re "/cgi/logurl.cgiMyPostdll?HOST:\u{0a}"))))
; HXDownload\s+Host\x3AArcadeHourspjpoptwql\u{2f}rlnjFrom\x3A
(assert (str.in_re X (re.++ (str.to_re "HXDownload") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:ArcadeHourspjpoptwql/rlnjFrom:\u{0a}"))))
; Host\x3AAddressDaemonUser-Agent\x3AUser-Agent\u{3a}
(assert (not (str.in_re X (str.to_re "Host:AddressDaemonUser-Agent:User-Agent:\u{0a}"))))
; /^[a-z\d\u{2b}\u{2f}\u{3d}]{48,256}$/iP
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 48 256) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/") (str.to_re "="))) (str.to_re "/iP\u{0a}"))))
; Referer\u{3a}Host\u{3a}port\u{3a}activity
(assert (not (str.in_re X (str.to_re "Referer:Host:port:activity\u{0a}"))))
(check-sat)
