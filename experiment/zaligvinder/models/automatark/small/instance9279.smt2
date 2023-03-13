(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /domain=[^&]*?([\u{3b}\u{60}]|\u{24}\u{28}|%3b|%60|%24%28)/Pi
(assert (not (str.in_re X (re.++ (str.to_re "/domain=") (re.* (re.comp (str.to_re "&"))) (re.union (str.to_re "$(") (str.to_re "%3b") (str.to_re "%60") (str.to_re "%24%28") (str.to_re ";") (str.to_re "`")) (str.to_re "/Pi\u{0a}")))))
; /^guid=[a-f0-9]{32}\u{26}state=(LOST|WORK|WAIT|RUN)/P
(assert (str.in_re X (re.++ (str.to_re "/guid=") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "&state=") (re.union (str.to_re "LOST") (str.to_re "WORK") (str.to_re "WAIT") (str.to_re "RUN")) (str.to_re "/P\u{0a}"))))
; Cookie\u{3a}AppName\x2FGRSI\|Server\|Host\x3Aorigin\x3Dsidefind
(assert (str.in_re X (str.to_re "Cookie:AppName/GRSI|Server|\u{13}Host:origin=sidefind\u{0a}")))
; rprpgbnrppb\u{2f}ci\d\x2ElStopperHost\x3AHost\u{3a}clvompycem\u{2f}cen\.vcn
(assert (str.in_re X (re.++ (str.to_re "rprpgbnrppb/ci") (re.range "0" "9") (str.to_re ".lStopperHost:Host:clvompycem/cen.vcn\u{0a}"))))
(check-sat)
