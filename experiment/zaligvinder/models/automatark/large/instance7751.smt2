(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; GmbH\x2FcommunicatortbHost\x3AUser-Agent\x3Aadblock\x2Elinkz\x2Ecom
(assert (not (str.in_re X (str.to_re "GmbH/communicatortbHost:User-Agent:adblock.linkz.com\u{0a}"))))
; /^Host:\s*?[a-f0-9]{63,64}\./Him
(assert (str.in_re X (re.++ (str.to_re "/Host:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 63 64) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "./Him\u{0a}"))))
; SystemSleuth1\x2E0versionHost\x3AArrowHost\u{3a}3Awebsearch\x2Edrsnsrch\x2EcomhostieiWonHost\u{3a}pjpoptwql\u{2f}rlnj
(assert (not (str.in_re X (str.to_re "SystemSleuth\u{13}1.0versionHost:ArrowHost:3Awebsearch.drsnsrch.com\u{13}hostieiWonHost:pjpoptwql/rlnj\u{0a}"))))
; /^Host\x3A\s+.*jaiku\x2Ecom/smiH
(assert (str.in_re X (re.++ (str.to_re "/Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* re.allchar) (str.to_re "jaiku.com/smiH\u{0a}"))))
; /filename\s*=\s*[^\r\n]*?\u{2e}swf[\u{22}\u{27}\u{3b}\s\r\n]/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ".swf") (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ";") (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/i\u{0a}")))))
(check-sat)
