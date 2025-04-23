@tool
extends EditorDebuggerPlugin

const PREFIX = 'tile-instances'

func _has_capture(prefix:String) -> bool:
	return prefix == PREFIX

func _capture(message:String, data:Array, session_id:int) -> bool:
	match message:
		"%s:get_id" % PREFIX:
			var all = []
			var sessions = get_sessions()
			for i in sessions.size():
				var session = sessions[i]
				if session.is_active():
					all.push_back(i)

			get_session(session_id).send_message("%s:session_id" % PREFIX, [{"id": session_id, "all": all}])
			return true

	return false
