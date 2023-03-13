(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; .*-[0-9]{1,10}.*
(assert (str.in_re X (re.++ (re.* re.allchar) (str.to_re "-") ((_ re.loop 1 10) (re.range "0" "9")) (re.* re.allchar) (str.to_re "\u{0a}"))))
; Host\x3A\sclvompycem\u{2f}cen\.vcn
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "clvompycem/cen.vcn\u{0a}"))))
; Host\x3A\s+Online100013Agentsvr\x5E\x5EMerlin
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Online100013Agentsvr^^Merlin\u{13}\u{0a}")))))
; /^images.php\?t=\d{2,7}$/U
(assert (str.in_re X (re.++ (str.to_re "/images") re.allchar (str.to_re "php?t=") ((_ re.loop 2 7) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
(check-sat)
