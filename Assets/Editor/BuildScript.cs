using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

public static class BuildScript
{
    [MenuItem("Woulwe/Build Android")]
    public static void BuildAndroid()
    {
        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        var go = new GameObject("SoloGame");
        go.AddComponent<SoloGameController>();
        EditorSceneManager.SaveScene(scene, "Assets/Scenes/Main.unity");

        PlayerSettings.productName = "Woulwe Solo";
        PlayerSettings.companyName = "Woulwe";
        PlayerSettings.applicationIdentifier = "com.woulwe.solo";
        PlayerSettings.SetApplicationIdentifier(BuildTargetGroup.Android, "com.woulwe.solo");
        PlayerSettings.bundleVersion = "1.0.0";
        PlayerSettings.Android.bundleVersionCode = 1;
        PlayerSettings.defaultScreenOrientation = ScreenOrientation.Portrait;

        BuildPipeline.BuildPlayer(new BuildPlayerOptions
        {
            scenes = new[] { "Assets/Scenes/Main.unity" },
            locationPathName = "build/outputs/WoulweSolo.apk",
            target = BuildTarget.Android,
            options = BuildOptions.None
        });
    }
}
