using UnityEngine;
using UnityEngine.UI;

public class SoloGameController : MonoBehaviour
{
    int completed;
    int score;
    Text status;

    void Start()
    {
        Application.targetFrameRate = 60;
        var canvas = new GameObject("Canvas", typeof(Canvas), typeof(CanvasScaler), typeof(GraphicRaycaster));
        var c = canvas.GetComponent<Canvas>();
        c.renderMode = RenderMode.ScreenSpaceOverlay;
        var scaler = canvas.GetComponent<CanvasScaler>();
        scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
        scaler.referenceResolution = new Vector2(1080, 1920);

        var statusGO = new GameObject("Status", typeof(Text));
        statusGO.transform.SetParent(canvas.transform, false);
        status = statusGO.GetComponent<Text>();
        status.font = Resources.GetBuiltinResource<Font>("Arial.ttf");
        status.fontSize = 48;
        status.alignment = TextAnchor.MiddleCenter;
        var sr = status.GetComponent<RectTransform>();
        sr.anchorMin = new Vector2(.05f,.9f); sr.anchorMax = new Vector2(.95f,.99f);
        sr.offsetMin = sr.offsetMax = Vector2.zero;

        var grid = new GameObject("Buttons", typeof(RectTransform), typeof(GridLayoutGroup));
        grid.transform.SetParent(canvas.transform, false);
        var gr = grid.GetComponent<GridLayoutGroup>();
        gr.cellSize = new Vector2(190,190);
        gr.spacing = new Vector2(15,15);
        gr.constraint = GridLayoutGroup.Constraint.FixedColumnCount;
        gr.constraintCount = 5;
        var rt = grid.GetComponent<RectTransform>();
        rt.anchorMin = new Vector2(.03f,.05f); rt.anchorMax = new Vector2(.97f,.88f);
        rt.offsetMin = rt.offsetMax = Vector2.zero;

        for (int i = 1; i <= 100; i++) CreateButton(grid.transform, i);
        UpdateStatus();
    }

    void CreateButton(Transform parent, int id)
    {
        var go = new GameObject("Challenge_" + id, typeof(Image), typeof(Button));
        go.transform.SetParent(parent, false);
        var image = go.GetComponent<Image>();
        image.color = new Color(.10f,.16f,.25f,1);
        var button = go.GetComponent<Button>();
        button.onClick.AddListener(() => Complete(id, button, image));

        var labelGO = new GameObject("Text", typeof(Text));
        labelGO.transform.SetParent(go.transform, false);
        var label = labelGO.GetComponent<Text>();
        label.font = Resources.GetBuiltinResource<Font>("Arial.ttf");
        label.text = id.ToString();
        label.fontSize = 42;
        label.alignment = TextAnchor.MiddleCenter;
        label.color = Color.white;
        var r = label.GetComponent<RectTransform>();
        r.anchorMin = Vector2.zero; r.anchorMax = Vector2.one;
        r.offsetMin = r.offsetMax = Vector2.zero;
    }

    void Complete(int id, Button button, Image image)
    {
        if (!button.interactable) return;
        completed++;
        score += 10;
        button.interactable = false;
        image.color = new Color(.12f,.45f,.25f,1);
        UpdateStatus();
    }

    void UpdateStatus()
    {
        if (status) status.text = "SOLO  •  ПРОЙДЕНО " + completed + "  •  ОЧКИ " + score;
    }
}
